`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    reg set;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .set(set),
        .q(q)
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
            set = 0;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();

            @(negedge clk);
            reset = 1;
            set = 0;
            d = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Set Operation (d=1)", test_num);
            reset_dut();

            @(negedge clk);
            set = 1;
            reset = 0;
            d = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Set Operation (d=0)", test_num);
            reset_dut();


            @(negedge clk);
            set = 1; d = 1; reset = 0;
            @(posedge clk);
            #1;


            @(negedge clk);
            set = 1; d = 0; reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold Operation (Retain 1)", test_num);
            reset_dut();


            @(negedge clk);
            set = 1; d = 1; reset = 0;
            @(posedge clk);
            #1;


            @(negedge clk);
            set = 0; reset = 0; d = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Simultaneous Set/Reset (Hold 1)", test_num);
            reset_dut();


            @(negedge clk);
            set = 1; d = 1; reset = 0;
            @(posedge clk);
            #1;


            @(negedge clk);
            set = 1; reset = 1; d = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Set/Reset (Hold 0)", test_num);
            reset_dut();


            @(negedge clk);
            set = 1; reset = 1; d = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Sequence Priority (Reset then Set)", test_num);
            reset_dut();


            @(negedge clk);
            reset = 1; set = 0;
            @(posedge clk);



            @(negedge clk);
            reset = 0; set = 1; d = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, d, reset, set, q);
    end

endmodule
