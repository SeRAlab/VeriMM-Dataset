`timescale 1ns/1ps

module qam_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [3:0] I_out;
    wire [3:0] Q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .I_out(I_out),
        .Q_out(Q_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in <= 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'h0 (Data=00 00)", test_num);
            data_in <= 4'h0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hD, 4'hD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'h5 (Data=01 01)", test_num);
            data_in <= 4'h5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'hA (Data=10 10)", test_num);
            data_in <= 4'hA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'hF (Data=11 11)", test_num);
            data_in <= 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h3, 4'h3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'h3 (Data=00 11)", test_num);
            data_in <= 4'h3;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hD, 4'h3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'hC (Data=11 00)", test_num);
            data_in <= 4'hC;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h3, 4'hD);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'h9 (Data=10 01)", test_num);
            data_in <= 4'h9;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'h6 (Data=01 10)", test_num);
            data_in <= 4'h6;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_transmitter Testbench");
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
        input [3:0] expected_I_out;
        input [3:0] expected_Q_out;
        begin
            if (expected_I_out === (expected_I_out ^ I_out ^ expected_I_out) &&
                expected_Q_out === (expected_Q_out ^ Q_out ^ expected_Q_out)) begin
                $display("PASS");
                $display("  Outputs: I_out=%h, Q_out=%h",
                         I_out, Q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_out=%h, Q_out=%h",
                         expected_I_out, expected_Q_out);
                $display("  Got:      I_out=%h, Q_out=%h",
                         I_out, Q_out);
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
        $dumpvars(0,clk, data_in, I_out, Q_out);
    end

endmodule
