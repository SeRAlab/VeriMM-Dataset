`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [1:0] operation;
    reg rst_n;
    reg [31:0] write_data;
    wire [31:0] read_data;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .address(address),
        .clk(clk),
        .operation(operation),
        .rst_n(rst_n),
        .write_data(write_data),
        .read_data(read_data),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            address = 0;
            operation = 0;
            write_data = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic Write/Read...", test_num);
            reset_dut();


            address = 32'h0000_0010;
            write_data = 32'hDEAD_BEEF;
            operation = 2'b01;
            @(posedge clk);


            operation = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Read uninitialized...", test_num);
            reset_dut();

            address = 32'h0000_0020;
            operation = 2'b10;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Multiple Address Check...", test_num);
            reset_dut();


            address = 32'hA0; write_data = 32'h1234_5678; operation = 2'b01;
            @(posedge clk);

            address = 32'hB0; write_data = 32'h8765_4321; operation = 2'b01;
            @(posedge clk);


            address = 32'hA0; operation = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Overwrite Check...", test_num);
            reset_dut();


            address = 32'h50; write_data = 32'hAAAA_AAAA; operation = 2'b01;
            @(posedge clk);

            address = 32'h50; write_data = 32'hBBBB_BBBB; operation = 2'b01;
            @(posedge clk);


            operation = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hBBBB_BBBB, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Idle operation check...", test_num);
            reset_dut();


            address = 32'h10;
            write_data = 32'hFFFF_FFFF;
            operation = 2'b00;
            @(posedge clk);


            operation = 2'b10;
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [31:0] expected_read_data;
        input expected_status;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h, status=%b",
                         read_data, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h, status=%b",
                         expected_read_data, expected_status);
                $display("  Got:      read_data=%h, status=%b",
                         read_data, status);
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
        $dumpvars(0,address, clk, operation, rst_n, write_data, read_data, status);
    end

endmodule
