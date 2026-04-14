`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data;
    reg re;
    reg we;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data(data),
        .re(re),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            data = 4'b0000;
            #10;

            we = 1;
            data = 4'b0000;
            #10;
            we = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (4'hA)", test_num);
            reset_dut();


            data = 4'hA;
            we = 1;
            re = 0;
            #10;


            we = 0;
            re = 1;
            #10;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (4'h5)", test_num);
            reset_dut();


            data = 4'h5;
            we = 1;
            re = 0;
            #10;


            we = 0;
            re = 1;
            #10;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data persistence check", test_num);
            reset_dut();


            data = 4'hC;
            we = 1;
            #10;


            we = 0;
            data = 4'h0;
            #10;


            re = 1;
            #10;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write All Ones (4'hF)", test_num);
            reset_dut();

            data = 4'hF;
            we = 1;
            #10;

            we = 0;
            re = 1;
            #10;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting value", test_num);
            reset_dut();


            data = 4'h1;
            we = 1;
            #10;


            data = 4'hE;
            #10;

            we = 0;
            re = 1;
            #10;

            #1;


            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        $dumpvars(0,data, re, we, q);
    end

endmodule
