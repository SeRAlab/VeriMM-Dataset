`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg rw;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel(channel),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .rw(rw),
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
            rst = 1;
            channel = 3'b000;
            data_in = 8'h00;
            rw = 0;
            start = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write/Read Channel 0", test_num);
            reset_dut();


            @(posedge clk);
            channel = 3'b000;
            data_in = 8'hA5;
            rw = 1;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;


            @(posedge clk);
            rw = 0;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Check Channel 7", test_num);
            reset_dut();


            @(posedge clk);
            channel = 3'b111;
            data_in = 8'hFF;
            rw = 1;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;


            @(posedge clk);
            rw = 0;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel Independence (Ch1 vs Ch2)", test_num);
            reset_dut();


            @(posedge clk);
            channel = 3'b001;
            data_in = 8'h11;
            rw = 1;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;


            @(posedge clk);
            channel = 3'b010;
            data_in = 8'h22;
            rw = 1;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;


            @(posedge clk);
            channel = 3'b001;
            rw = 0;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start Signal Requirement", test_num);
            reset_dut();


            @(posedge clk);
            channel = 3'b011;
            data_in = 8'h33;
            rw = 1;
            start = 0;
            repeat (5) @(posedge clk);


            @(posedge clk);
            rw = 0;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Effect on Storage", test_num);
            reset_dut();


            @(posedge clk);
            channel = 3'b100;
            data_in = 8'h44;
            rw = 1;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;


            reset_dut();


            @(posedge clk);
            channel = 3'b100;
            rw = 0;
            start = 1;
            wait(done);
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        $dumpvars(0,channel, clk, data_in, rst, rw, start, data_out, done);
    end

endmodule
