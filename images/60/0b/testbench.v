`timescale 1ns/1ps

module demux_1to2_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg in;
    reg sel;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    demux_1to2 dut (
        .en(en),
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            en = 1; in = 0; sel = 0;
            $display("Test %0d: Disabled (en=1), in=0, sel=0", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            en = 1; in = 1; sel = 0;
            $display("Test %0d: Disabled (en=1), in=1, sel=0", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            en = 1; in = 1; sel = 1;
            $display("Test %0d: Disabled (en=1), in=1, sel=1", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            en = 0; in = 0; sel = 0;
            $display("Test %0d: Enabled (en=0), in=0, sel=0", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            en = 0; in = 1; sel = 0;
            $display("Test %0d: Enabled (en=0), in=1, sel=0 (Data to out[0])", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            en = 0; in = 0; sel = 1;
            $display("Test %0d: Enabled (en=0), in=0, sel=1", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            en = 0; in = 1; sel = 1;
            $display("Test %0d: Enabled (en=0), in=1, sel=1 (Data to out[1])", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("demux_1to2 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_out;
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
