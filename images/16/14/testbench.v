`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [1:0] cmd_type;
    reg [31:0] data_in;
    reg rst;
    wire [31:0] data_out;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .addr(addr),
        .clk(clk),
        .cmd_type(cmd_type),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 0;
            cmd_type = 0;
            data_in = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Valid Write Operation", test_num);
            @(posedge clk);
            cmd_type = 2'b01;
            addr = 32'h0000_0010;
            data_in = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Valid Read Operation", test_num);


            @(posedge clk);
            cmd_type = 2'b01;
            addr = 32'd20;
            data_in = 32'h1234_5678;


            @(posedge clk);
            cmd_type = 2'b00;
            addr = 32'd20;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Out of Range Write", test_num);
            @(posedge clk);
            cmd_type = 2'b01;
            addr = 32'd300;
            data_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Out of Range Read", test_num);
            @(posedge clk);
            cmd_type = 2'b00;
            addr = 32'h0000_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Invalid Command Type", test_num);
            @(posedge clk);
            cmd_type = 2'b10;
            addr = 32'd50;
            data_in = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Boundary Check Address 0", test_num);
            @(posedge clk);
            cmd_type = 2'b01;
            addr = 32'd0;
            data_in = 32'hCAFE_BABE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Boundary Check Address 255", test_num);
            @(posedge clk);
            cmd_type = 2'b01;
            addr = 32'd255;
            data_in = 32'hBEEF_FEED;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Boundary Check Address 256", test_num);
            @(posedge clk);
            cmd_type = 2'b01;
            addr = 32'd256;
            data_in = 32'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_status;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, status=%b",
                         data_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, status=%b",
                         expected_data_out, expected_status);
                $display("  Got:      data_out=%h, status=%b",
                         data_out, status);
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
        $dumpvars(0,addr, clk, cmd_type, data_in, rst, data_out, status);
    end

endmodule
