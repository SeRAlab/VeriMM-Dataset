`timescale 1ns/1ps

module dac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] data_in;
    reg enable;
    wire [11:0] data_out_high;
    wire [11:0] data_out_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_controller dut (
        .data_in(data_in),
        .enable(enable),
        .data_out_high(data_out_high),
        .data_out_low(data_out_low)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic split check with enable=1", test_num);
            enable = 1'b1;
            data_in = 24'hABC123;
            #10;
            #1;

            check_outputs(12'hABC, 12'h123);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Check enable=0 behavior (Outputs should be 0)", test_num);
            enable = 1'b0;
            data_in = 24'hABC123;
            #10;
            #1;

            check_outputs(12'h000, 12'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Boundary check - All zeros", test_num);
            enable = 1'b1;
            data_in = 24'h000000;
            #10;
            #1;

            check_outputs(12'h000, 12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Boundary check - All ones", test_num);
            enable = 1'b1;
            data_in = 24'hFFFFFF;
            #10;
            #1;

            check_outputs(12'hFFF, 12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Alternating bit pattern", test_num);
            enable = 1'b1;
            data_in = 24'hAAAAAA;
            #10;
            #1;

            check_outputs(12'hAAA, 12'hAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Inverse alternating bit pattern", test_num);
            enable = 1'b1;
            data_in = 24'h555555;
            #10;
            #1;

            check_outputs(12'h555, 12'h555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Random data pattern 1", test_num);
            enable = 1'b1;
            data_in = 24'h123456;
            #10;
            #1;

            check_outputs(12'h123, 12'h456);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random data pattern 2", test_num);
            enable = 1'b1;
            data_in = 24'hFEDCBA;
            #10;
            #1;

            check_outputs(12'hFED, 12'hCBA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [11:0] expected_data_out_high;
        input [11:0] expected_data_out_low;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out_high === (expected_data_out_high ^ data_out_high ^ expected_data_out_high) &&
                expected_data_out_low === (expected_data_out_low ^ data_out_low ^ expected_data_out_low)) begin
                $display("PASS");
                $display("  Outputs: data_out_high=%h, data_out_low=%h",
                         data_out_high, data_out_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_high=%h, data_out_low=%h",
                         expected_data_out_high, expected_data_out_low);
                $display("  Got:      data_out_high=%h, data_out_low=%h",
                         data_out_high, data_out_low);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
