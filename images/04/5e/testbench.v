`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg request_a;
    reg request_b;
    reg reset;
    wire ack_a;
    wire ack_b;
    wire [7:0] mem_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .request_a(request_a),
        .request_b(request_b),
        .reset(reset),
        .ack_a(ack_a),
        .ack_b(ack_b),
        .mem_data(mem_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request_a = 0;
            request_b = 0;
            data_a = 0;
            data_b = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Idle State (No requests)", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Channel A Request Only", test_num);
            reset_dut();
            data_a = 8'hAA;
            request_a = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Channel B Request Only", test_num);
            reset_dut();
            data_b = 8'hBB;
            request_b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Simultaneous Requests (Priority A > B)", test_num);
            reset_dut();
            data_a = 8'hA1;
            data_b = 8'hB1;
            request_a = 1;
            request_b = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 8'hA1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Priority Preemption (A interrupts B)", test_num);
            reset_dut();


            data_a = 8'hA2;
            data_b = 8'hB2;
            request_b = 1;
            @(posedge clk);
            #1;


            request_a = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 0, 8'hA2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Request Withdrawal", test_num);
            reset_dut();


            data_a = 8'hA3;
            request_a = 1;
            @(posedge clk);


            request_a = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Sequential Transfers (A then B)", test_num);
            reset_dut();


            data_a = 8'h11;
            request_a = 1;
            @(posedge clk);


            request_a = 0;
            data_b = 8'h22;
            request_b = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 8'h22);
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
        input expected_ack_a;
        input expected_ack_b;
        input [7:0] expected_mem_data;
        begin
            if (expected_ack_a === (expected_ack_a ^ ack_a ^ expected_ack_a) &&
                expected_ack_b === (expected_ack_b ^ ack_b ^ expected_ack_b) &&
                expected_mem_data === (expected_mem_data ^ mem_data ^ expected_mem_data)) begin
                $display("PASS");
                $display("  Outputs: ack_a=%b, ack_b=%b, mem_data=%h",
                         ack_a, ack_b, mem_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_a=%b, ack_b=%b, mem_data=%h",
                         expected_ack_a, expected_ack_b, expected_mem_data);
                $display("  Got:      ack_a=%b, ack_b=%b, mem_data=%h",
                         ack_a, ack_b, mem_data);
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
        $dumpvars(0,clk, data_a, data_b, request_a, request_b, reset, ack_a, ack_b, mem_data);
    end

endmodule
