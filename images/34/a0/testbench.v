`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg RE;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

        begin
            WE = 0;
            D = 4'h0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write 4'h5 and Read", test_num);


            D = 4'h5;
            WE = 1;
            #10;
            WE = 0;


            wait(RE == 1);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write 4'hA and Read", test_num);

            D = 4'hA;
            WE = 1;
            #10;
            WE = 0;

            wait(RE == 1);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Data Hold (WE=0) Test", test_num);


            D = 4'hF;
            WE = 1;
            #10;


            WE = 0;
            D = 4'h3;
            #10;

            wait(RE == 1);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write 4'h0 and Read", test_num);

            D = 4'h0;
            WE = 1;
            #10;
            WE = 0;

            wait(RE == 1);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Test", test_num);


            D = 4'h1;
            WE = 1;
            #10;


            D = 4'hE;
            #10;
            WE = 0;

            wait(RE == 1);
            #2;
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
        $display("dram_cell Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, RE, WE, Q);
    end

endmodule
