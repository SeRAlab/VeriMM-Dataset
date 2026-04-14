`timescale 1ns/1ps

module QAM_modulator_tb;

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
    QAM_modulator dut (
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
            data_in = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0000", test_num);
            data_in = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, 4'b1101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0001", test_num);
            data_in = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0010", test_num);
            data_in = 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0011", test_num);
            data_in = 4'b0011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0100", test_num);
            data_in = 4'b0100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111, 4'b1101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0101", test_num);
            data_in = 4'b0101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0110", test_num);
            data_in = 4'b0110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111, 4'b0011);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 0111", test_num);
            data_in = 4'b0111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111, 4'b0001);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1000", test_num);
            data_in = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011, 4'b1101);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1001", test_num);
            data_in = 4'b1001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011, 4'b1111);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1010", test_num);
            data_in = 4'b1010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011, 4'b0011);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1011", test_num);
            data_in = 4'b1011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011, 4'b0001);
        end
        endtask

    task testcase013;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1100", test_num);
            data_in = 4'b1100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001, 4'b1101);
        end
        endtask

    task testcase014;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1101", test_num);
            data_in = 4'b1101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001, 4'b1111);
        end
        endtask

    task testcase015;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1110", test_num);
            data_in = 4'b1110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001, 4'b0011);
        end
        endtask

    task testcase016;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: data_in = 1111", test_num);
            data_in = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001, 4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("QAM_modulator Testbench");
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
        $dumpvars(0,clk, data_in, I_out, Q_out);
    end

endmodule
