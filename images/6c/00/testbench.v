`timescale 1ns/1ps

module twos_complement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twos_complement dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .data_out(data_out),
        .done(done)
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
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Input = 8'h01 (Decimal 1)", test_num);
            reset_dut();
            data_in = 8'h01;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done);
            #1 #1;
 check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Input = 8'h00 (Decimal 0)", test_num);
            reset_dut();
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            #1 #1;
 check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Input = 8'hFF (Decimal -1)", test_num);
            reset_dut();
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            #1 #1;
 check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Input = 8'h7F (Decimal 127)", test_num);
            reset_dut();
            data_in = 8'h7F;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            #1 #1;
 check_outputs(8'h81, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Input = 8'h80 (Decimal -128)", test_num);
            reset_dut();
            data_in = 8'h80;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            #1 #1;
 check_outputs(8'h80, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Input = 8'hAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            #1 #1;
 check_outputs(8'h56, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Input = 8'h55", test_num);
            reset_dut();
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            #1 #1;
 check_outputs(8'hAB, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("twos_complement Testbench");
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_in, reset, start, data_out, done);
    end

endmodule
