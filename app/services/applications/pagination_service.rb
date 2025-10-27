module Applications
  class PaginationService
    def self.call(page = 1, per_page = 25)
      applications = Application.page(page).per(per_page)

      {
        current_page: applications.current_page,
        per_page: applications.limit_value,
        total_pages: applications.total_pages,
        total_count: applications.total_count,
        applications: applications.map { |application| ApplicationDto.new(application) }
      }
    end
  end
end
