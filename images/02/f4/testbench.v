`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg rst;
    wire [7:0] encoded_out1;
    wire [7:0] encoded_out2;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .encoded_out1(encoded_out1),
        .encoded_out2(encoded_out2),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (5'b00000)", test_num);
            reset_dut();

            data_in = 5'b00000;


            wait(valid == 1);
            @(posedge clk);



            #1;




            check_outputs(8'h00, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (5'b11111)", test_num);
            reset_dut();

            data_in = 5'b11111;

            wait(valid == 1);
            @(posedge clk);


            #1;



            check_outputs(8'hFF, 8'hE0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating (5'b10101)", test_num);
            reset_dut();

            data_in = 5'b10101;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hAA, 8'h40, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating (5'b01010)", test_num);
            reset_dut();

            data_in = 5'b01010;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h55, 8'h20, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit LSB (5'b00001)", test_num);
            reset_dut();

            data_in = 5'b00001;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h01, 8'h08, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit MSB (5'b10000)", test_num);
            reset_dut();

            data_in = 5'b10000;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h80, 8'h01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random pattern (5'b11001)", test_num);
            reset_dut();

            data_in = 5'b11001;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hC9, 8'h12, 1'b1);
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
        testcase007();
        
        
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
        input [7:0] expected_encoded_out1;
        input [7:0] expected_encoded_out2;
        input expected_valid;
        begin
            if (expected_encoded_out1 === (expected_encoded_out1 ^ encoded_out1 ^ expected_encoded_out1) &&
                expected_encoded_out2 === (expected_encoded_out2 ^ encoded_out2 ^ expected_encoded_out2) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out1=%h, encoded_out2=%h, valid=%b",
                         encoded_out1, encoded_out2, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out1=%h, encoded_out2=%h, valid=%b",
                         expected_encoded_out1, expected_encoded_out2, expected_valid);
                $display("  Got:      encoded_out1=%h, encoded_out2=%h, valid=%b",
                         encoded_out1, encoded_out2, valid);
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
        $dumpvars(0,clk, data_in, rst, encoded_out1, encoded_out2, valid);
    end

endmodule
