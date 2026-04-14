`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs zero", test_num);
            x0 = 16'h0; x1 = 16'h0; x2 = 16'h0; x3 = 16'h0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unit impulse on x0", test_num);
            x0 = 16'h1; x1 = 16'h0; x2 = 16'h0; x3 = 16'h0;
            #1;

            check_outputs(32'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unit impulse on x1", test_num);
            x0 = 16'h0; x1 = 16'h1; x2 = 16'h0; x3 = 16'h0;
            #1;

            check_outputs(32'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unit value on all inputs", test_num);
            x0 = 16'h1; x1 = 16'h1; x2 = 16'h1; x3 = 16'h1;
            #1;

            check_outputs(32'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Scaled small values", test_num);
            x0 = 16'd10; x1 = 16'd20; x2 = 16'd30; x3 = 16'd40;
            #1;

            check_outputs(32'h12C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum input values", test_num);
            x0 = 16'hFFFF; x1 = 16'hFFFF; x2 = 16'hFFFF; x3 = 16'hFFFF;
            #1;

            check_outputs(32'h9FFF6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
