`timescale 1ns/1ps

module dac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] digital_in;
    wire [15:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_controller dut (
        .digital_in(digital_in),
        .analog_out(analog_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Minimum Value", test_num);
        digital_in = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Maximum Value", test_num);
        digital_in = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Mid-point Value (0x8000)", test_num);
        digital_in = 16'h8000;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: 0x7FFF Value", test_num);
        digital_in = 16'h7FFF;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits (0xAAAA)", test_num);
        digital_in = 16'hAAAA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating Bits (0x5555)", test_num);
        digital_in = 16'h5555;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Random Pattern (0x1234)", test_num);
        digital_in = 16'h1234;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Random Pattern (0xBEEF)", test_num);
        digital_in = 16'hBEEF;
        #1;

        check_outputs(16'hBEEF);
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
        input [15:0] expected_analog_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_out === (expected_analog_out ^ analog_out ^ expected_analog_out)) begin
                $display("PASS");
                $display("  Outputs: analog_out=%h",
                         analog_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_out=%h",
                         expected_analog_out);
                $display("  Got:      analog_out=%h",
                         analog_out);
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
