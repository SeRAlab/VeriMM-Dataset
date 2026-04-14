`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg RE;
    reg RST;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .D(D),
        .RE(RE),
        .RST(RST),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RST = 0;
        forever #5 RST = ~RST;
    end

        task reset_dut;

        begin
            RST = 1;
            WE = 0;
            RE = 0;
            D = 8'h00;
            #10;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write then Read", test_num);
            reset_dut();

            WE = 1; D = 8'hAA; RE = 0;
            #10;

            WE = 0; RE = 1;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying data overwrite", test_num);
            reset_dut();

            WE = 1; D = 8'h55;
            #10;

            D = 8'h33;
            #10;

            WE = 0; RE = 1;
            #10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying WE prevents writing when low", test_num);
            reset_dut();

            WE = 1; D = 8'hF0;
            #10;

            WE = 0; D = 8'h0F;
            #10;

            RE = 1;
            #10;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying RST priority over WE", test_num);
            reset_dut();

            RST = 1; WE = 1; D = 8'hFF;
            #10;
            RST = 0; WE = 0; RE = 1;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying RE requirement for output", test_num);
            reset_dut();

            WE = 1; D = 8'hCC;
            #10;

            WE = 0; RE = 0;
            #10;

            RE = 1;
            #10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_Q;
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
        $dumpvars(0,D, RE, RST, WE, clk, Q);
    end

endmodule
