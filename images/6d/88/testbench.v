`timescale 1ns/1ps

module subtractor_with_borrow_tb;

    // Testbench signals (sequential circuit)
    reg borrow_in;
    reg clk;
    reg [7:0] data1;
    reg [7:0] data2;
    reg reset;
    reg start;
    wire borrow_out;
    wire [7:0] difference;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_with_borrow dut (
        .borrow_in(borrow_in),
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .reset(reset),
        .start(start),
        .borrow_out(borrow_out),
        .difference(difference),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            start = 0;
            data1 = 0;
            data2 = 0;
            borrow_in = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: 50 - 20 - 0", test_num);
            data1 = 8'd50;
            data2 = 8'd20;
            borrow_in = 1'b0;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b0, 8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: 50 - 20 - 1", test_num);
            data1 = 8'd50;
            data2 = 8'd20;
            borrow_in = 1'b1;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b0, 8'd29, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: 10 - 20 - 0", test_num);
            data1 = 8'd10;
            data2 = 8'd20;
            borrow_in = 1'b0;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b1, 8'hF6, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: 10 - 20 - 1", test_num);
            data1 = 8'd10;
            data2 = 8'd20;
            borrow_in = 1'b1;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b1, 8'hF5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: 100 - 100 - 0", test_num);
            data1 = 8'd100;
            data2 = 8'd100;
            borrow_in = 1'b0;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b0, 8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: 100 - 100 - 1", test_num);
            data1 = 8'd100;
            data2 = 8'd100;
            borrow_in = 1'b1;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b1, 8'hFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: 255 - 0 - 0", test_num);
            data1 = 8'hFF;
            data2 = 8'h00;
            borrow_in = 1'b0;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b0, 8'hFF, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: 0 - 255 - 1", test_num);
            data1 = 8'h00;
            data2 = 8'hFF;
            borrow_in = 1'b1;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            #1;

            check_outputs(1'b1, 8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_with_borrow Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_borrow_out;
        input [7:0] expected_difference;
        input expected_done;
        begin
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_difference === (expected_difference ^ difference ^ expected_difference) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, difference=%h, done=%b",
                         borrow_out, difference, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, difference=%h, done=%b",
                         expected_borrow_out, expected_difference, expected_done);
                $display("  Got:      borrow_out=%b, difference=%h, done=%b",
                         borrow_out, difference, done);
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
        $dumpvars(0,borrow_in, clk, data1, data2, reset, start, borrow_out, difference, done);
    end

endmodule
