`timescale 1ns/1ps

module turbo_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] csi;
    reg [1:0] received_bits;
    reg rst;
    wire [1:0] estimated_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_decoder dut (
        .clk(clk),
        .csi(csi),
        .received_bits(received_bits),
        .rst(rst),
        .estimated_bits(estimated_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            csi = 0;
            received_bits = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros, High CSI", test_num);
            reset_dut();
            csi = 2'b11;
            received_bits = 2'b00;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones, High CSI", test_num);
            reset_dut();
            csi = 2'b11;
            received_bits = 2'b11;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits, Medium CSI", test_num);
            reset_dut();
            csi = 2'b10;
            received_bits = 2'b10;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data with Low CSI (Noisy Channel)", test_num);
            reset_dut();
            csi = 2'b01;
            received_bits = 2'b01;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Error Correction Potential", test_num);
            reset_dut();
            csi = 2'b11;
            received_bits = 2'b11;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_decoder Testbench");
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
        input [1:0] expected_estimated_bits;
        begin
            if (expected_estimated_bits === (expected_estimated_bits ^ estimated_bits ^ expected_estimated_bits)) begin
                $display("PASS");
                $display("  Outputs: estimated_bits=%h",
                         estimated_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_bits=%h",
                         expected_estimated_bits);
                $display("  Got:      estimated_bits=%h",
                         estimated_bits);
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
        $dumpvars(0,clk, csi, received_bits, rst, estimated_bits);
    end

endmodule
