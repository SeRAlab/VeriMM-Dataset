`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [4:0] encoded_out1;
    wire [4:0] encoded_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .encoded_out1(encoded_out1),
        .encoded_out2(encoded_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0000", test_num);
            reset_dut();
            data_in = 4'b0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1111", test_num);
            reset_dut();
            data_in = 4'b1111;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'h1F, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1010", test_num);
            reset_dut();
            data_in = 4'b1010;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h15, 5'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0101", test_num);
            reset_dut();
            data_in = 4'b0101;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h0A, 5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1000", test_num);
            reset_dut();
            data_in = 4'b1000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'h10, 5'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0001", test_num);
            reset_dut();
            data_in = 4'b0001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h01, 5'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input [4:0] expected_encoded_out1;
        input [4:0] expected_encoded_out2;
        begin
            if (expected_encoded_out1 === (expected_encoded_out1 ^ encoded_out1 ^ expected_encoded_out1) &&
                expected_encoded_out2 === (expected_encoded_out2 ^ encoded_out2 ^ expected_encoded_out2)) begin
                $display("PASS");
                $display("  Outputs: encoded_out1=%h, encoded_out2=%h",
                         encoded_out1, encoded_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out1=%h, encoded_out2=%h",
                         expected_encoded_out1, expected_encoded_out2);
                $display("  Got:      encoded_out1=%h, encoded_out2=%h",
                         encoded_out1, encoded_out2);
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
        $dumpvars(0,clk, data_in, reset, encoded_out1, encoded_out2);
    end

endmodule
