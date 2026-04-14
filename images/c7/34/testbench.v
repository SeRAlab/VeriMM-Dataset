`timescale 1ns/1ps

module increment_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    increment dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Incrementing 0x0000", test_num);
            in = 16'h0000;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Incrementing a small value (0x0005)", test_num);
            in = 16'h0005;
            #1;

            check_outputs(16'h0006);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Incrementing value with carry across low byte (0x00FF)", test_num);
            in = 16'h00FF;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Incrementing mid-range value (0x1234)", test_num);
            in = 16'h1234;
            #1;

            check_outputs(16'h1235);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Incrementing sign-bit transition (0x7FFF)", test_num);
            in = 16'h7FFF;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Incrementing large value (0xAAAA)", test_num);
            in = 16'hAAAA;
            #1;

            check_outputs(16'hAAAB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Incrementing high-byte transition (0xFF00)", test_num);
            in = 16'hFF00;
            #1;

            check_outputs(16'hFF01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Incrementing maximum value (Overflow: 0xFFFF)", test_num);
            in = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("increment Testbench");
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
