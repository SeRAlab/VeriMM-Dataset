`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [3:0] range_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_input(adc_input),
        .range_out(range_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower bound of Range 0", test_num);
        adc_input = 24'd0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Upper bound of Range 0", test_num);
        adc_input = 24'd15;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower bound of Range 1", test_num);
        adc_input = 24'd16;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Middle range (Range 4: 64-79)", test_num);
        adc_input = 24'd70;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary of Range 7 and 8", test_num);
        adc_input = 24'd128;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower bound of Range 15 (240-255)", test_num);
        adc_input = 24'd240;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Upper bound of Range 15 (240-255)", test_num);
        adc_input = 24'd255;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Value just above 255 (clamping check)", test_num);
        adc_input = 24'd256;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large value (clamping check)", test_num);
        adc_input = 24'd1024;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum possible 24-bit value", test_num);
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
        $display("adc_decoder Testbench");
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
        input [3:0] expected_range_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range_out === (expected_range_out ^ range_out ^ expected_range_out)) begin
                $display("PASS");
                $display("  Outputs: range_out=%h",
                         range_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range_out=%h",
                         expected_range_out);
                $display("  Got:      range_out=%h",
                         range_out);
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
