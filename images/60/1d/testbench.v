`timescale 1ns/1ps

module bitwise_xor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in1;
    reg [31:0] data_in2;
    reg rst_n;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_xor dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in1 = 0;
            data_in2 = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Identity Property (X ^ 0)", test_num);
            reset_dut();
            data_in1 = 32'hA5A5_5A5A;
            data_in2 = 32'h0000_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Self-XOR Property (X ^ X)", test_num);
            reset_dut();
            data_in1 = 32'hFFFF_FFFF;
            data_in2 = 32'hFFFF_FFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bit Inversion", test_num);
            reset_dut();
            data_in1 = 32'h1234_5678;
            data_in2 = 32'hFFFF_FFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(~32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Standard XOR Operation", test_num);
            reset_dut();
            data_in1 = 32'h1111_2222;
            data_in2 = 32'h4444_8888;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h1111_2222 ^ 32'h4444_8888);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Reset Priority", test_num);
            reset_dut();
            data_in1 = 32'hCAFE_BABE;
            data_in2 = 32'hBABE_CAFE;
            @(posedge clk);
            #1;
            rst_n = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_xor Testbench");
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in1, data_in2, rst_n, data_out);
    end

endmodule
