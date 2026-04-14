`timescale 1ns/1ps

module mux3to1_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in0;
    reg in1;
    reg in2;
    reg reset;
    reg [2:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux3to1 dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .reset(reset),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            sel = 3'b000;
            in0 = 0;
            in1 = 0;
            in2 = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (0)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 3'b000;
            in0 = 0;
            in1 = 1;
            in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (1)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 3'b000;
            in0 = 1;
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (0)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 3'b001;
            in0 = 1;
            in1 = 0;
            in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (1)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 3'b001;
            in0 = 0;
            in1 = 1;
            in2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (0)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 3'b010;
            in0 = 1;
            in1 = 1;
            in2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (1)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 3'b010;
            in0 = 0;
            in1 = 0;
            in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Switching test", test_num);
            reset_dut();


            in0 = 1; in1 = 0; in2 = 1;


            @(negedge clk);
            sel = 3'b001;
            @(posedge clk);
            #1;


            @(negedge clk);
            sel = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux3to1 Testbench");
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, in0, in1, in2, reset, sel, out);
    end

endmodule
