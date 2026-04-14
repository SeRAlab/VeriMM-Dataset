`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [7:0] qam_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .qam_out(qam_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b0000 (I=0, Q=0)", test_num);
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b0001 (I=0, Q=1)", test_num);
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b0010 (I=0, Q=2)", test_num);
            reset_dut();
            data_in = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b0011 (I=0, Q=3)", test_num);
            reset_dut();
            data_in = 4'b0011;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b0100 (I=1, Q=0)", test_num);
            reset_dut();
            data_in = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b1000 (I=2, Q=0)", test_num);
            reset_dut();
            data_in = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b1100 (I=3, Q=0)", test_num);
            reset_dut();
            data_in = 4'b1100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b0110 (I=1, Q=2)", test_num);
            reset_dut();
            data_in = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h12);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b1001 (I=2, Q=1)", test_num);
            reset_dut();
            data_in = 4'b1001;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h21);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Input 4'b1111 (I=3, Q=3)", test_num);
            reset_dut();
            data_in = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h33);
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
        input [7:0] expected_qam_out;
        begin
            if (expected_qam_out === (expected_qam_out ^ qam_out ^ expected_qam_out)) begin
                $display("PASS");
                $display("  Outputs: qam_out=%h",
                         qam_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qam_out=%h",
                         expected_qam_out);
                $display("  Got:      qam_out=%h",
                         qam_out);
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
        $dumpvars(0,clk, data_in, rst, qam_out);
    end

endmodule
