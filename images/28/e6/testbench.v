`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'h00;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);

            src_addr = 8'h10;
            dest_addr = 8'h20;
            data_in = 8'hA5;
            start = 1;

            @(posedge clk);
            #2;
            start = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Transfer with Different Data/Addresses", test_num);

            src_addr = 8'hFF;
            dest_addr = 8'hEE;
            data_in = 8'h5A;
            start = 1;

            @(posedge clk);
            #2;
            start = 0;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: No Transfer with Start Low", test_num);

            src_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 8'h77;
            start = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Consecutive Transfers", test_num);


            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            data_in = 8'h11;
            start = 1;
            @(posedge clk);
            #2;


            src_addr = 8'hCC;
            dest_addr = 8'hDD;
            data_in = 8'h22;
            start = 1;
            @(posedge clk);
            #2;
            start = 0;

            #1;


            check_outputs(8'h22);
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, dest_addr, src_addr, start, data_out);
    end

endmodule
