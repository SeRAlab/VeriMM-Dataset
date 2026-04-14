`timescale 1ns/1ps

module decoder_7to128_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] in;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_7to128 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing minimum value (in = 0)", test_num);
            in = 7'd0;
            #1;

            check_outputs(128'h00000000000000000000000000000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing maximum value (in = 127)", test_num);
            in = 7'd127;
            #1;

            check_outputs(128'h80000000000000000000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing power of 2 boundaries (in = 1, 2, 4, 8, 16, 32, 64)", test_num);

            in = 7'd1;
            #1;

            check_outputs(128'd1 << 1);

            in = 7'd2;
            #1;

            check_outputs(128'd1 << 2);

            in = 7'd4;
            #1;

            check_outputs(128'd1 << 4);

            in = 7'd8;
            #1;

            check_outputs(128'd1 << 8);

            in = 7'd16;
            #1;

            check_outputs(128'd1 << 16);

            in = 7'd32;
            #1;

            check_outputs(128'd1 << 32);

            in = 7'd64;
            #1;

            check_outputs(128'd1 << 64);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing arbitrary values (in = 42, 73, 100)", test_num);

            in = 7'd42;
            #1;

            check_outputs(128'd1 << 42);

            in = 7'd73;
            #1;

            check_outputs(128'd1 << 73);

            in = 7'd100;
            #1;

            check_outputs(128'd1 << 100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing bit transitions (in = 63, 64, 65)", test_num);

            in = 7'd63;
            #1;

            check_outputs(128'd1 << 63);

            in = 7'd64;
            #1;

            check_outputs(128'd1 << 64);

            in = 7'd65;
            #1;

            check_outputs(128'd1 << 65);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_7to128 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [127:0] expected_out;
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
