`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] reg_read_addr_1;
    reg [2:0] reg_read_addr_2;
    reg [15:0] reg_write_data;
    reg [2:0] reg_write_dest;
    reg reg_write_en;
    reg rst;
    wire [15:0] reg_read_data_1;
    wire [15:0] reg_read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_write_data(reg_write_data),
        .reg_write_dest(reg_write_dest),
        .reg_write_en(reg_write_en),
        .rst(rst),
        .reg_read_data_1(reg_read_data_1),
        .reg_read_data_2(reg_read_data_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            reg_write_en = 0;
            reg_write_dest = 0;
            reg_write_data = 0;
            reg_read_addr_1 = 0;
            reg_read_addr_2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();
            reg_read_addr_1 = 3'd1;
            reg_read_addr_2 = 3'd7;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            reg_write_en = 1;
            reg_write_dest = 3'd1;
            reg_write_data = 16'hAAAA;
            @(posedge clk);


            reg_write_dest = 3'd2;
            reg_write_data = 16'h5555;
            @(posedge clk);

            reg_write_en = 0;
            reg_read_addr_1 = 3'd1;
            reg_read_addr_2 = 3'd2;
            #2;
            #1;

            check_outputs(16'hAAAA, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register 0 Constant Zero Check", test_num);
            reset_dut();


            reg_write_en = 1;
            reg_write_dest = 3'd0;
            reg_write_data = 16'hFFFF;
            @(posedge clk);

            reg_write_en = 0;
            reg_read_addr_1 = 3'd0;
            reg_read_addr_2 = 3'd0;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Disable Check", test_num);
            reset_dut();


            reg_write_en = 0;
            reg_write_dest = 3'd3;
            reg_write_data = 16'h1234;
            @(posedge clk);

            reg_read_addr_1 = 3'd3;
            reg_read_addr_2 = 3'd0;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register Overwrite Check", test_num);
            reset_dut();


            reg_write_en = 1;
            reg_write_dest = 3'd4;
            reg_write_data = 16'h1111;
            @(posedge clk);


            reg_write_data = 16'h2222;
            @(posedge clk);

            reg_write_en = 0;
            reg_read_addr_1 = 3'd4;
            reg_read_addr_2 = 3'd4;
            #2;
            #1;

            check_outputs(16'h2222, 16'h2222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dual Port Read Check", test_num);
            reset_dut();


            reg_write_en = 1;
            reg_write_dest = 3'd5;
            reg_write_data = 16'hBEEF;
            @(posedge clk);


            reg_write_dest = 3'd6;
            reg_write_data = 16'hCAFE;
            @(posedge clk);

            reg_write_en = 0;
            reg_read_addr_1 = 3'd5;
            reg_read_addr_2 = 3'd6;
            #2;
            #1;

            check_outputs(16'hBEEF, 16'hCAFE);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Register File Boundary Check", test_num);
            reset_dut();


            reg_write_en = 1;
            for(i=1; i<8; i=i+1) begin
                reg_write_dest = i;
                reg_write_data = 16'h8000 + i;
                @(posedge clk);
            end

            reg_write_en = 0;
            reg_read_addr_1 = 3'd7;
            reg_read_addr_2 = 3'd1;
            #2;
            #1;

            check_outputs(16'h8007, 16'h8001);
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
        input [15:0] expected_reg_read_data_1;
        input [15:0] expected_reg_read_data_2;
        begin
            if (expected_reg_read_data_1 === (expected_reg_read_data_1 ^ reg_read_data_1 ^ expected_reg_read_data_1) &&
                expected_reg_read_data_2 === (expected_reg_read_data_2 ^ reg_read_data_2 ^ expected_reg_read_data_2)) begin
                $display("PASS");
                $display("  Outputs: reg_read_data_1=%h, reg_read_data_2=%h",
                         reg_read_data_1, reg_read_data_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_read_data_1=%h, reg_read_data_2=%h",
                         expected_reg_read_data_1, expected_reg_read_data_2);
                $display("  Got:      reg_read_data_1=%h, reg_read_data_2=%h",
                         reg_read_data_1, reg_read_data_2);
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
        $dumpvars(0,clk, reg_read_addr_1, reg_read_addr_2, reg_write_data, reg_write_dest, reg_write_en, rst, reg_read_data_1, reg_read_data_2);
    end

endmodule
