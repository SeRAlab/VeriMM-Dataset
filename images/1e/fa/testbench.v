`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg enable;
    reg reset;
    reg [7:0] src_addr;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .enable(enable),
        .reset(reset),
        .src_addr(src_addr),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Transfer", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;


            repeat(2) @(posedge clk);
            while(busy === 1'b1) @(posedge clk);



            #1;




            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Different Address Transfer", test_num);
            reset_dut();

            src_addr = 8'h55;
            dest_addr = 8'h11;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);
            while(busy === 1'b1) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No Enable Idle Check", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'hEE;
            enable = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Transfers", test_num);
            reset_dut();


            src_addr = 8'h01;
            dest_addr = 8'h02;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            while(busy === 1'b1) @(posedge clk);


            src_addr = 8'h88;
            dest_addr = 8'h99;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            while(busy === 1'b1) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h88);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset During Operation", test_num);
            reset_dut();

            src_addr = 8'hCC;
            dest_addr = 8'hDD;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;


            wait(busy === 1'b1);
            repeat(1) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00);
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
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,clk, dest_addr, enable, reset, src_addr, busy, data_out);
    end

endmodule
