`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [3:0] I_out;
    wire [3:0] Q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
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
            rst = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Data 0000 (I=-3, Q=-3)", test_num);
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hD, 4'hD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Data 0001 (I=-3, Q=-1)", test_num);
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hD, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Data 0011 (I=-3, Q=1)", test_num);
            reset_dut();
            data_in = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hD, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Data 0010 (I=-3, Q=3)", test_num);
            reset_dut();
            data_in = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hD, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Data 0100 (I=-1, Q=-3)", test_num);
            reset_dut();
            data_in = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'hD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Data 0101 (I=-1, Q=-1)", test_num);
            reset_dut();
            data_in = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Data 0111 (I=-1, Q=1)", test_num);
            reset_dut();
            data_in = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Data 0110 (I=-1, Q=3)", test_num);
            reset_dut();
            data_in = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'h3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Data 1100 (I=1, Q=-3)", test_num);
            reset_dut();
            data_in = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 4'hD);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Data 1101 (I=1, Q=-1)", test_num);
            reset_dut();
            data_in = 4'b1101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 4'hF);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: Data 1111 (I=1, Q=1)", test_num);
            reset_dut();
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: Data 1110 (I=1, Q=3)", test_num);
            reset_dut();
            data_in = 4'b1110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 4'h3);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test Case %0d: Data 1000 (I=3, Q=-3)", test_num);
            reset_dut();
            data_in = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 4'hD);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test Case %0d: Data 1001 (I=3, Q=-1)", test_num);
            reset_dut();
            data_in = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 4'hF);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test Case %0d: Data 1011 (I=3, Q=1)", test_num);
            reset_dut();
            data_in = 4'b1011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 4'h1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Test Case %0d: Data 1010 (I=3, Q=3)", test_num);
            reset_dut();
            data_in = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        $dumpvars(0,clk, data_in, rst, I_out, Q_out);
    end

endmodule
