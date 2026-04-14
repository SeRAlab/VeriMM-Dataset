`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [31:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
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
            @(negedge clk);
            reset = 1;
            data_in = 8'h00;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential bytes 0x11, 0x22, 0x33, 0x44", test_num);
            reset_dut();
            data_in = 8'h11; @(negedge clk);
            data_in = 8'h22; @(negedge clk);
            data_in = 8'h33; @(negedge clk);
            data_in = 8'h44; @(negedge clk);
            #2;
            #1;

            check_outputs(32'h11223344, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Pattern DEADBEEF", test_num);
            reset_dut();
            data_in = 8'hDE; @(negedge clk);
            data_in = 8'hAD; @(negedge clk);
            data_in = 8'hBE; @(negedge clk);
            data_in = 8'hEF; @(negedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            data_in = 8'h00; @(negedge clk);
            data_in = 8'h00; @(negedge clk);
            data_in = 8'h00; @(negedge clk);
            data_in = 8'h00; @(negedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            data_in = 8'hFF; @(negedge clk);
            data_in = 8'hFF; @(negedge clk);
            data_in = 8'hFF; @(negedge clk);
            data_in = 8'hFF; @(negedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern (0x55, 0xAA)", test_num);
            reset_dut();
            data_in = 8'h55; @(negedge clk);
            data_in = 8'hAA; @(negedge clk);
            data_in = 8'h55; @(negedge clk);
            data_in = 8'hAA; @(negedge clk);
            #2;
            #1;

            check_outputs(32'h55AA55AA, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incomplete cycle check (only 2 cycles)", test_num);
            reset_dut();
            data_in = 8'hA1; @(negedge clk);
            data_in = 8'hB2; @(negedge clk);
            #2;


            if (done === 1'b0) begin
                $display("PASS: Done is low as expected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Done should be low after only 2 cycles");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, reset, data_out, done);
    end

endmodule
