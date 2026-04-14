`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] dest_addr1;
    reg [7:0] dest_addr2;
    reg reset;
    reg [7:0] src_addr1;
    reg [7:0] src_addr2;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .control(control),
        .dest_addr1(dest_addr1),
        .dest_addr2(dest_addr2),
        .reset(reset),
        .src_addr1(src_addr1),
        .src_addr2(src_addr2),
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
            control = 0;
            src_addr1 = 8'h00;
            src_addr2 = 8'h00;
            dest_addr1 = 8'h00;
            dest_addr2 = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Transfer", test_num);
            reset_dut();

            control = 0;
            src_addr1 = 8'hA5;
            src_addr2 = 8'h5A;
            dest_addr1 = 8'h10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Transfer", test_num);
            reset_dut();

            control = 1;
            src_addr1 = 8'h11;
            src_addr2 = 8'hBB;
            dest_addr2 = 8'h20;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Channel Switching", test_num);
            reset_dut();


            src_addr1 = 8'hC1;
            src_addr2 = 8'hC2;


            control = 0;
            @(posedge clk);


            #1;
            control = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hC2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Address Change Persistence", test_num);
            reset_dut();

            control = 0;
            src_addr1 = 8'h12;
            @(posedge clk);

            #1;
            src_addr1 = 8'h34;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel Isolation Test", test_num);
            reset_dut();

            control = 0;
            src_addr1 = 8'hEE;
            src_addr2 = 8'h00;
            @(posedge clk);

            #1;
            src_addr2 = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hEE);
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
        $dumpvars(0,clk, control, dest_addr1, dest_addr2, reset, src_addr1, src_addr2, data_out);
    end

endmodule
