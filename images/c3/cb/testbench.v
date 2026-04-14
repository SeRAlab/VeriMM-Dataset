`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg sel0;
    reg sel1;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel0(sel0),
        .sel1(sel1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 0;
            in1 = 0;
            in2 = 0;
            in3 = 0;
            sel0 = 0;
            sel1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Select in0=1");
            reset_dut();
            test_num = 1;
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            sel1 = 0; sel0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Select in1=1");
            reset_dut();
            test_num = 2;
            in0 = 0; in1 = 1; in2 = 0; in3 = 0;
            sel1 = 0; sel0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Select in2=1");
            reset_dut();
            test_num = 3;
            in0 = 0; in1 = 0; in2 = 1; in3 = 0;
            sel1 = 1; sel0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Select in3=1");
            reset_dut();
            test_num = 4;
            in0 = 0; in1 = 0; in2 = 0; in3 = 1;
            sel1 = 1; sel0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Select in0=0 (others 1)");
            reset_dut();
            test_num = 5;
            in0 = 0; in1 = 1; in2 = 1; in3 = 1;
            sel1 = 0; sel0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Select in1=0 (others 1)");
            reset_dut();
            test_num = 6;
            in0 = 1; in1 = 0; in2 = 1; in3 = 1;
            sel1 = 0; sel0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Select in2=0 (others 1)");
            reset_dut();
            test_num = 7;
            in0 = 1; in1 = 1; in2 = 0; in3 = 1;
            sel1 = 1; sel0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Select in3=0 (others 1)");
            reset_dut();
            test_num = 8;
            in0 = 1; in1 = 1; in2 = 1; in3 = 0;
            sel1 = 1; sel0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Data changes on in0 while selected");
            reset_dut();
            test_num = 9;
            sel1 = 0; sel0 = 0;
            in0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);

            in0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Switching select lines");
            reset_dut();
            test_num = 10;
            in0 = 1; in1 = 0; in2 = 1; in3 = 0;


            sel1 = 0; sel0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);


            sel1 = 0; sel0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);


            sel1 = 1; sel0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);


            sel1 = 1; sel0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        $dumpvars(0,clk, in0, in1, in2, in3, sel0, sel1, out);
    end

endmodule
