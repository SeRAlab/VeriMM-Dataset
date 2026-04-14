`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [3:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .status(status)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Range [0-15] - Lower Boundary (0)", test_num);
        adc_input = 24'd0;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Range [0-15] - Upper Boundary (15)", test_num);
        adc_input = 24'd15;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Range [16-255] - Lower Boundary (16)", test_num);
        adc_input = 24'd16;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Range [16-255] - Upper Boundary (255)", test_num);
        adc_input = 24'd255;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Range [256-4095] - Lower Boundary (256)", test_num);
        adc_input = 24'd256;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Range [256-4095] - Upper Boundary (4095)", test_num);
        adc_input = 24'd4095;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Range [4096-65535] - Lower Boundary (4096)", test_num);
        adc_input = 24'd4096;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Range [4096-65535] - Upper Boundary (65535)", test_num);
        adc_input = 24'd65535;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Range [> 65535] - Lower Boundary (65536)", test_num);
        adc_input = 24'd65536;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Range [> 65535] - Max Value (24-bit)", test_num);
        adc_input = 24'hFFFFFF;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
