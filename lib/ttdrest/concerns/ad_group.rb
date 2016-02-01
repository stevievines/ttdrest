module Ttdrest
  module Concerns
    module AdGroup
      def get_ad_groups(campaign_id, options = {})
        path = "/adgroups/#{campaign_id}"
        params = {}
        result = get(path, params)
        return result
      end
      
      def get_ad_group(ad_group_id, options = {})
        path = "/adgroup/#{ad_group_id}"
        params = {}
        result = get(path, params)
        return result
      end

      def create_ad_group(campaign_id, name, budget_in_dollars, daily_budget_in_dollars, pacing_enabled, base_bid_cpm_in_dollars, max_bid_cpm_in_dollars, creative_ids = [], options = {})
        path = "/adgroup"
        content_type = 'application/json'
        params = options[:params] || {}
        
        # Build main ad group data hash
        ad_group_data = build_ad_group_data(nil, campaign_id, name, budget_in_dollars, daily_budget_in_dollars, pacing_enabled, base_bid_cpm_in_dollars, max_bid_cpm_in_dollars, creative_ids, params)
        
        result = data_post(path, content_type, ad_group_data.to_json)
        return result
      end
      
      def update_ad_group(ad_group_id, campaign_id, name, budget_in_dollars, daily_budget_in_dollars, pacing_enabled, base_bid_cpm_in_dollars, max_bid_cpm_in_dollars, creative_ids = [], options = {})
        path = "/adgroup"
        content_type = 'application/json'
        params = options[:params] || {}
        
        # Build main ad group data hash
        ad_group_data = build_ad_group_data(ad_group_id, campaign_id, name, budget_in_dollars, daily_budget_in_dollars, pacing_enabled, base_bid_cpm_in_dollars, max_bid_cpm_in_dollars, creative_ids, params)
        
        result = data_put(path, content_type, ad_group_data.to_json)
        return result
      end
      
      def build_ad_group_data(ad_group_id, campaign_id, name, budget_in_dollars, daily_budget_in_dollars, pacing_enabled, base_bid_cpm_in_dollars, max_bid_cpm_in_dollars, creative_ids = [], params = {})
        if !params[:currency_code].nil?
          currency_code = params[:currency_code]
        else
          currency_code = "USD"
        end
        # Build main ad group data hash
        ad_group_data = {}
        if !ad_group_id.nil?
          ad_group_data = ad_group_data.merge({"AdGroupId" => ad_group_id})
        end
        if !campaign_id.nil?
          ad_group_data = ad_group_data.merge({"CampaignId" => campaign_id})
        end
        if !name.nil?
          ad_group_data = ad_group_data.merge({"AdGroupName" => name})
        end
        if !params[:description].nil?
          ad_group_data = ad_group_data.merge({"Description" => params[:description]})
        end
        if !params[:is_enabled].nil?
          ad_group_data = ad_group_data.merge({"IsEnabled" => params[:is_enabled]})
        end
        if !params[:industry_category_id].nil?
          ad_group_data = ad_group_data.merge({"IndustryCategoryId" => params[:industry_category_id]})
        end
        if !params[:availability].nil?
          ad_group_data = ad_group_data.merge({"Availability" => params[:availability]})
        end
        
        # Build RTB ad group data hash
        rtb_ad_group_data = {}
        budget_data = {}
        if !budget_in_dollars.nil?
          budget_data = budget_data.merge({"Budget" => {"Amount" => budget_in_dollars, "CurrencyCode" => currency_code}})
        end
        if !params[:budget_in_impressions].nil?
          budget_data = budget_data.merge({"BudgetInImpressions" => params[:budget_in_impressions]})
        end
        if !daily_budget_in_dollars.nil?
          budget_data = budget_data.merge({"DailyBudget" => {"Amount" => daily_budget_in_dollars, "CurrencyCode" => currency_code}})
        end
        if !params[:daily_budget_in_impressions].nil?
          budget_data = budget_data.merge({"DailyBudgetInImpressions" => params[:daily_budget_in_impressions]})
        end
        if !pacing_enabled.nil?
          budget_data = budget_data.merge({"PacingEnabled" => pacing_enabled})
        end
        if !budget_data.empty?
          rtb_ad_group_data = rtb_ad_group_data.merge({"BudgetSettings" => budget_data})
        end
        if !base_bid_cpm_in_dollars.nil?
          rtb_ad_group_data = rtb_ad_group_data.merge({"BaseBidCPMInUSDollars" => {"Amount" => base_bid_cpm_in_dollars, "CurrencyCode" => currency_code}})
        end
        if !max_bid_cpm_in_dollars.nil?
          rtb_ad_group_data = rtb_ad_group_data.merge({"MaxBidCPMInUSDollars" => {"Amount" => max_bid_cpm_in_dollars, "CurrencyCode" => currency_code}})
        end
        if !creative_ids.empty? 
          rtb_ad_group_data = rtb_ad_group_data.merge({"CreativeIds" => creative_ids})
        end
        if !params[:site_list_ids].nil?
          site_targeting_data = {"SiteListIds" => params[:site_list_ids]}
          if !params[:site_list_fall_through_adjustment].nil?
            site_targeting_data = site_targeting_data.merge({"SiteListFallThroughAdjustment" => params[:site_list_fall_through_adjustment]})
          end
          rtb_ad_group_data = rtb_ad_group_data.merge({"SiteTargeting" => site_targeting_data})
        end
        fold_data = {}
        if !params[:above_fold_adjustment].nil?
          fold_data = fold_data.merge({"AboveFoldAdjustment" => params[:above_fold_adjustment]})
        end
        if !params[:below_fold_adjustment].nil?
          fold_data = fold_data.merge({"BelowFoldAdjustment" => params[:below_fold_adjustment]})
        end
        if !params[:unknown_fold_adjustment].nil?
          fold_data = fold_data.merge({"UnknownFoldAdjustment" => params[:unknown_fold_adjustment]})
        end
        if !fold_data.empty?
          rtb_ad_group_data = rtb_ad_group_data.merge({"FoldTargeting" => fold_data})
        end
        if !params[:budget_in_impressions].nil?
          rtb_ad_group_data = rtb_ad_group_data.merge({"BudgetInImpressions" => params[:budget_in_impressions]})
        end
        if !params[:daily_budget_in_impressions].nil?
          rtb_ad_group_data = rtb_ad_group_data.merge({"DailyBudgetInImpressions" => params[:daily_budget_in_impressions]})
        end
        frequency_data = {}
        if !params[:frequency_pricing_slope].nil?
          frequency_data = frequency_data.merge({"FrequencyPricingSlopeCPM" => {"Amount" => params[:frequency_pricing_slope], "CurrencyCode" => currency_code}})
        end
        if !params[:frequency_period_in_minutes].nil?
          frequency_data = frequency_data.merge({"FrequencyPeriodInMinutes" => params[:frequency_period_in_minutes]})
        end
        if !params[:frequency_cap].nil?
          frequency_data = frequency_data.merge({"FrequencyCap" => params[:frequency_cap]})
        end
        if !frequency_data.empty?
          rtb_ad_group_data = rtb_ad_group_data.merge({"FrequencySettings" => frequency_data})
        end
        if !params[:audience_id].nil?
          # Build audience data hash
          audience_data = {
            "AudienceId" => params[:audience_id]
            }
          if !params[:recency_adjustments].blank?
            audience_data = audience_data.merge({"RecencyAdjustments" => params[:recency_adjustments]})
          else
            audience_data = audience_data.merge({"RecencyAdjustments" => [{"RecencyWindowStartInMinutes" => 0, "Adjustment" => 1.0}]})
          end
          if !params[:regency_exclusion_window_in_minutes].blank?
            audience_data = audience_data.merge({"RecencyExclusionWindowInMinutes" => params[:regency_exclusion_window_in_minutes]})
          else
            audience_data = audience_data.merge({"RecencyExclusionWindowInMinutes" => 129600}) #default to 129600 (90 days)
          end
          rtb_ad_group_data = rtb_ad_group_data.merge({"AudienceTargeting" => audience_data})
        end
        if !params[:geo_segment_adjustments].nil?
          rtb_ad_group_data = rtb_ad_group_data.merge({"GeoSegmentAdjustments" => params[:geo_segment_adjustments]})
        end
        #TODO: AdFormatAdjustments 
        #TODO: ROIGoal
        #TODO: UserTimeTargeting 
        #TODO: SupplyVendorAdjustments 
        #TODO: BrowserAdjustments 
        #TODO: OSAdjustments 
        #TODO: OSFamilyAdjustments 
        #TODO: DeviceTypeAdjustments
        #TODO: RenderingContextAdjustments
        #TODO: AutoOptimizationSettings
        #TODO: ContractTargeting
        #TODO: VideoTargeting
        #TODO: SiteQualitySettings
        #TODO: NielsenSettings
        #TODO: ComscoreSettings
        #TODO: LanguageTargeting
        
        if !rtb_ad_group_data.empty?
          ad_group_data = ad_group_data.merge({"RTBAttributes" => rtb_ad_group_data})
        end
        
        return ad_group_data
      end
      
    end
  end
end
