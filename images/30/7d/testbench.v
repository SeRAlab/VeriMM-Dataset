`timescale 1ns/1ps

module pcie_interface_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg [1:0] req_type;
    reg rst;
    wire [31:0] data_out;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_interface dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .req_type(req_type),
        .rst(rst),
        .data_out(data_out),
        .success(success)
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
            data_in = 0;
            req_type = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write Operation", test_num);
            reset_dut();


            addr = 32'h0000_1000;
            data_in = 32'hDEAD_BEEF;
            req_type = 2'b01;

            @(posedge clk);
            #1;



            #1;




            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Read Operation", test_num);
            reset_dut();


            addr = 32'h0000_1000;
            req_type = 2'b10;

            @(posedge clk);
            #1;


            #1;



            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write then Read back same address", test_num);
            reset_dut();


            addr = 32'h0000_00A0;
            data_in = 32'h1234_5678;
            req_type = 2'b01;
            @(posedge clk);


            req_type = 2'b00;
            @(posedge clk);


            addr = 32'h0000_00A0;
            req_type = 2'b10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: IDLE req_type behavior", test_num);
            reset_dut();

            addr = 32'hFFFF_FFFF;
            data_in = 32'hAAAA_BBBB;
            req_type = 2'b00;

            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential writes to different addresses", test_num);
            reset_dut();


            addr = 32'h4;
            data_in = 32'hCAFE_BABE;
            req_type = 2'b01;
            @(posedge clk);


            addr = 32'h8;
            data_in = 32'h5555_AAAA;
            req_type = 2'b01;
            @(posedge clk);


            addr = 32'h4;
            req_type = 2'b10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hCAFE_BABE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_interface Testbench");
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
        input [31:0] expected_data_out;
        input expected_success;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, success=%b",
                         data_out, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, success=%b",
                         expected_data_out, expected_success);
                $display("  Got:      data_out=%h, success=%b",
                         data_out, success);
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
        $dumpvars(0,addr, clk, data_in, req_type, rst, data_out, success);
    end

endmodule
