`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg load;
    reg rst;
    reg sin;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .d(d),
        .load(load),
        .rst(rst),
        .sin(sin),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            d = 4'b0000;
            sin = 0;
            @(posedge clk);
            #1 rst = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Parallel Load", test_num);
            reset_dut();
            load = 1;
            d = 4'hA;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Right (sin=1)", test_num);
            reset_dut();

            load = 1;
            d = 4'h1;
            @(posedge clk);
            #1 load = 0;


            sin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Right 4 times", test_num);
            reset_dut();
            sin = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Priority", test_num);
            reset_dut();

            load = 1;
            d = 4'hF;
            @(posedge clk);
            #1;

            rst = 1;
            load = 1;
            d = 4'h5;
            @(posedge clk);
            #1;
            rst = 0;
            load = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Load Priority", test_num);
            reset_dut();
            load = 1;
            d = 4'hC;
            sin = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Serial Pattern Shift", test_num);
            reset_dut();

            sin = 1; @(posedge clk);

            #1 sin = 0; @(posedge clk);

            #1 sin = 1; @(posedge clk);

            #1 sin = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, load, rst, sin, q);
    end

endmodule
