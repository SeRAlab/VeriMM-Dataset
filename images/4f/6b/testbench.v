`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_address;
    reg [1:0] write_address;
    reg [31:0] write_data;
    reg write_enable;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .read_address(read_address),
        .write_address(write_address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            write_enable = 0;
            write_address = 0;
            read_address = 0;
            write_data = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write and Read Reg 0", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'b00;
            write_data = 32'hA5A5A5A5;


            @(negedge clk);
            write_enable = 0;


            read_address = 2'b00;


            @(negedge clk);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write and Read Reg 3", test_num);
            reset_dut();

            @(negedge clk);
            write_enable = 1;
            write_address = 2'b11;
            write_data = 32'h12345678;

            @(negedge clk);
            write_enable = 0;
            read_address = 2'b11;

            @(negedge clk);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Write Enable", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'b01;
            write_data = 32'hFFFFFFFF;


            @(negedge clk);
            write_enable = 0;
            write_address = 2'b01;
            write_data = 32'h00000000;

            @(negedge clk);
            read_address = 2'b01;

            @(negedge clk);

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwriting Register", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'b10;
            write_data = 32'h11111111;


            @(negedge clk);
            write_data = 32'h22222222;

            @(negedge clk);
            write_enable = 0;
            read_address = 2'b10;

            @(negedge clk);
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Read Address Change", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'b00;
            write_data = 32'hAAAA_AAAA;
            @(negedge clk);
            write_address = 2'b01;
            write_data = 32'h5555_5555;
            @(negedge clk);
            write_enable = 0;


            read_address = 2'b00;
            @(negedge clk);


            read_address = 2'b01;
            @(negedge clk);

            #1;


            check_outputs(32'h5555_5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file Testbench");
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
        $dumpvars(0,clk, read_address, write_address, write_data, write_enable, read_data);
    end

endmodule
