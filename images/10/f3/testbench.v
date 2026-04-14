`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_addr;
    reg we;
    reg [1:0] write_addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Write to Reg 0", test_num);
            reset_dut();
            we = 1;
            write_addr = 2'b00;
            write_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b00;
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write to Reg 3", test_num);
            reset_dut();
            we = 1;
            write_addr = 2'b11;
            write_data = 32'hCAFEBABE;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b11;
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write Enable Validation", test_num);
            reset_dut();

            we = 1;
            write_addr = 2'b01;
            write_data = 32'h11111111;
            @(posedge clk);
            #1;

            we = 0;
            write_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            read_addr = 2'b01;
            #1;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Address Independence", test_num);
            reset_dut();

            we = 1;
            write_addr = 2'b11;
            write_data = 32'h33333333;
            @(posedge clk);
            #1;

            we = 1;
            write_addr = 2'b10;
            write_data = 32'h22222222;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b11;
            #1;
            #1;

            check_outputs(32'h33333333);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Read Address Switching", test_num);
            reset_dut();

            we = 1;
            write_addr = 2'b00;
            write_data = 32'hAAAA5555;
            @(posedge clk);
            #1;

            we = 1;
            write_addr = 2'b01;
            write_data = 32'h5555AAAA;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b00;
            #1;
            read_addr = 2'b01;
            #1;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_addr, we, write_addr, write_data, read_data);
    end

endmodule
