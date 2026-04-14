`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg start;
    wire done;
    wire [5:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .done(done),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 4'b0000;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b0000 (All Zeros)", test_num);
            reset_dut();
            data_in = 4'b0000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 6'b0000_00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b1111 (All Ones)", test_num);
            reset_dut();
            data_in = 4'b1111;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 6'b1111_00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b1010", test_num);
            reset_dut();
            data_in = 4'b1010;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 6'b1010_00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b0101", test_num);
            reset_dut();
            data_in = 4'b0101;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 6'b0101_00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b1000", test_num);
            reset_dut();
            data_in = 4'b1000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 6'b1000_11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b0001", test_num);
            reset_dut();
            data_in = 4'b0001;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 6'b0001_11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In = 4'b1100", test_num);
            reset_dut();
            data_in = 4'b1100;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 6'b1100_10);
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
        input expected_done;
        input [5:0] expected_encoded_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, encoded_out=%h",
                         done, encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, encoded_out=%h",
                         expected_done, expected_encoded_out);
                $display("  Got:      done=%b, encoded_out=%h",
                         done, encoded_out);
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
        $dumpvars(0,clk, data_in, reset, start, done, encoded_out);
    end

endmodule
