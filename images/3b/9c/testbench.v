`timescale 1ns/1ps

module simple_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] inp;
    reg rst;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_fsm dut (
        .clk(clk),
        .inp(inp),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            inp = 5'b00000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S0 -> S1 -> S2 (Expected out=1)", test_num);
            reset_dut();

            inp = 5'd1;
            @(posedge clk);

            #1 inp = 5'd0;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S0 -> S0 (Expected out=0)", test_num);
            reset_dut();

            inp = 5'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S0 -> S1 -> S1 (Expected out=0)", test_num);
            reset_dut();

            inp = 5'd1;
            @(posedge clk);

            #1 inp = 5'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S0 -> S1 -> S2 -> S3 (Expected out=0)", test_num);
            reset_dut();

            inp = 5'd1; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);

            #1 inp = 5'd1; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S0 -> S1 -> S2 -> S0 (Expected out=0)", test_num);
            reset_dut();

            inp = 5'd1; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S3 -> S1 -> S2 (Expected out=1)", test_num);
            reset_dut();

            inp = 5'd1; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);

            #1 inp = 5'd1; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition S3 -> S3 (Expected out=0)", test_num);
            reset_dut();

            inp = 5'd1; @(posedge clk);

            #1 inp = 5'd0; @(posedge clk);

            #1 inp = 5'd1; @(posedge clk);

            #1 inp = 5'd1; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Path S0->S1->S2->S3->S1->S2->S0 (Expected out=0)", test_num);
            reset_dut();
            inp = 5'd1; @(posedge clk);
            #1 inp = 5'd0; @(posedge clk);
            #1 inp = 5'd1; @(posedge clk);
            #1 inp = 5'd0; @(posedge clk);
            #1 inp = 5'd0; @(posedge clk);
            #1 inp = 5'd0; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_fsm Testbench");
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
        $dumpvars(0,clk, inp, rst, out);
    end

endmodule
