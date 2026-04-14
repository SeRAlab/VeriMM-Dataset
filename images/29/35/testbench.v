`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    reg valid;
    wire [5:0] encoded_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .encoded_out(encoded_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4'b0000", test_num);
            reset_dut();

            data_in = 4'b0000;
            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(ready == 1);
            @(posedge clk);




            #1;





            check_outputs(6'b000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4'b1111", test_num);
            reset_dut();

            data_in = 4'b1111;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(6'b111111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4'b1010", test_num);
            reset_dut();

            data_in = 4'b1010;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(6'b101010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4'b0101", test_num);
            reset_dut();

            data_in = 4'b0101;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(6'b010101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4'b1000", test_num);
            reset_dut();

            data_in = 4'b1000;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(6'b100011, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4'b0001", test_num);
            reset_dut();

            data_in = 4'b0001;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(6'b000111, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Recovery", test_num);
            reset_dut();

            data_in = 4'b1100;
            valid = 1;
            @(posedge clk);
            reset_dut();

            data_in = 4'b1100;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(6'b110010, 1'b1);
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
        input [5:0] expected_encoded_out;
        input expected_ready;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, ready=%b",
                         encoded_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, ready=%b",
                         expected_encoded_out, expected_ready);
                $display("  Got:      encoded_out=%h, ready=%b",
                         encoded_out, ready);
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
        $dumpvars(0,clk, data_in, rst, valid, encoded_out, ready);
    end

endmodule
