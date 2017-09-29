module Codekraft
  module Api
    class Configuration
      attr_accessor :prod_url, :default_mail_from, :endpoints, :resources

      def endpoints
        {
          fetchAll: {
            method: "get",
            route: "",
            service: "fetchAll",
            auth: [:doorkeeper_authorize!, :authorize_admin!]
          },
          fetchOne: {
            method: "get",
           route: "/:id",
            service: "fetchOne",
            auth: [:doorkeeper_authorize!]
          },
          create: {
            method: "post",
            route: "",
            service: "create",
            auth: [:doorkeeper_authorize!]
          },
          update: {
            method: "put",
            route: "/:id",
            service: "update",
            auth: [:doorkeeper_authorize!]
          },
          delete: {
            method: "delete",
            route: "/:id",
            service: "destroy",
            auth: [:doorkeeper_authorize!]
          }
        }.merge!(@endpoints ||= {})
      end

      def resources
        {
          user: {
            service: Codekraft::Api::Service::User.new,
            endpoints: {
              create: {
                auth: nil
              },
              me: {
                method: "get",
                route: "/me",
                service: {
                  function: "fetchOne",
                  params: {id: "current_user.id"},
                  auth: [:doorkeeper_authorize!]
                }
              }
            },
            serializer: {
              attributes: [:firstname, :lastname, :email, :role, :no_password]
            }
          }
        }.merge!(@resources ||= {})
      end
      
    end

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end
  end
end
