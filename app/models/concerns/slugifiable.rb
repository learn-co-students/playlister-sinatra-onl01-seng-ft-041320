module Slugifiable
    module ClassMethods
        def find_by_slug(slug)
            self.all.detect {|object| object.slug == slug}
        end
        
    end

    module InstanceMethods
        def slug
            name.parameterize
        end
        
    end

end