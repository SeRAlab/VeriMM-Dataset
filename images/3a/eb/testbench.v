`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command_type;
    reg enable;
    reg rst_n;
    reg [15:0] start_address;
    reg [31:0] write_data;
    wire [31:0] read_data;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .command_type(command_type),
        .enable(enable),
        .rst_n(rst_n),
        .start_address(start_address),
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
            enable = 0;
            command_type = CMD_IDLE;
            start_address = 16'h0;
            write_data = 32'h0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write Operation", test_num);
            reset_dut();

            command_type = CMD_WRITE;
            start_address = 16'h1000;
            write_data = 32'hDEADBEEF;
            enable = 1;

            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Read Operation", test_num);
            reset_dut();

            command_type = CMD_READ;
            start_address = 16'h2000;
            enable = 1;

            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(read_data, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command with Enable Low", test_num);
            reset_dut();

            command_type = CMD_WRITE;
            start_address = 16'h3000;
            write_data = 32'hAAAA5555;
            enable = 0;

            repeat(3) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Invalid Command Type", test_num);
            reset_dut();

            command_type = CMD_ERR;
            start_address = 16'h4000;
            enable = 1;

            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read after Write Sequence", test_num);
            reset_dut();


            command_type = CMD_WRITE;
            start_address = 16'h00AA;
            write_data = 32'h12345678;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);


            command_type = CMD_READ;
            start_address = 16'h00AA;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h12345678, 1'b1);
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
        $dumpvars(0,clk, command_type, enable, rst_n, start_address, write_data, read_data, status);
    end

endmodule
