`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire busy;
    wire done;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data(data),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .busy(busy),
        .done(done),
        .read_data(read_data)
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
        src_addr = 8'h0;
        dest_addr = 8'h0;
        data = 8'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Basic Transfer", test_num);
        reset_dut();


        src_addr = 8'h10;
        dest_addr = 8'h20;
        data = 8'hAB;
        start = 1;

        @(posedge clk);
        start = 0;



        wait(done == 1);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b1, 8'hAB);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Different Address and Data", test_num);
        reset_dut();

        src_addr = 8'hFF;
        dest_addr = 8'h00;
        data = 8'h55;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Zero Data Transfer", test_num);
        reset_dut();

        src_addr = 8'h00;
        dest_addr = 8'h00;
        data = 8'h00;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Max Data Transfer", test_num);
        reset_dut();

        src_addr = 8'hAA;
        dest_addr = 8'hBB;
        data = 8'hFF;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Stability After Done", test_num);
        reset_dut();

        src_addr = 8'h12;
        dest_addr = 8'h34;
        data = 8'h77;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(done == 1);

        repeat(3) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 8'h77);
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
        input expected_busy;
        input expected_done;
        input [7:0] expected_read_data;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, read_data=%h",
                         busy, done, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, read_data=%h",
                         expected_busy, expected_done, expected_read_data);
                $display("  Got:      busy=%b, done=%b, read_data=%h",
                         busy, done, read_data);
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
        $dumpvars(0,clk, data, dest_addr, reset, src_addr, start, busy, done, read_data);
    end

endmodule
