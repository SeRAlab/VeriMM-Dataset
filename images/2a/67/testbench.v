`timescale 1ns/1ps

module pcie_request_handler_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg request;
    reg rst;
    wire ack;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_request_handler dut (
        .clk(clk),
        .data_in(data_in),
        .request(request),
        .rst(rst),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            request = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1 #1;
 check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request with Data 0xAA", test_num);
            reset_dut();

            data_in = 8'hAA;
            request = 1;
            @(posedge clk);
            request = 0;


            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request with Data 0x55", test_num);
            reset_dut();

            data_in = 8'h55;
            request = 1;
            @(posedge clk);
            request = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request with Data 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            request = 1;
            @(posedge clk);
            request = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying ack de-assertion (pulse duration)", test_num);
            reset_dut();

            data_in = 8'h12;
            request = 1;
            @(posedge clk);
            request = 0;

            @(posedge clk);
            @(posedge clk);

            #1 #1;
 check_outputs(1'b0, 8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request with Data 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            request = 1;
            @(posedge clk);
            request = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_request_handler Testbench");
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
        input expected_ack;
        input [7:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, request, rst, ack, data_out);
    end

endmodule
