`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_reg1;
    reg [2:0] read_reg2;
    reg [15:0] write_data;
    reg write_enable;
    reg [2:0] write_reg;
    wire [15:0] read_data1;
    wire [15:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_data(write_data),
        .write_enable(write_enable),
        .write_reg(write_reg),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin

            write_enable = 0;
            write_reg = 0;
            write_data = 0;
            read_reg1 = 0;
            read_reg2 = 0;




            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                write_reg = i;
                write_data = 16'h0000;
                write_enable = 1;
                @(posedge clk);
            end
            write_enable = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Write 0xABCD to Reg 1 and read it back on both ports", test_num);

            @(negedge clk);
            write_reg = 3'd1;
            write_data = 16'hABCD;
            write_enable = 1;

            @(posedge clk);
            #1;
            write_enable = 0;
            read_reg1 = 3'd1;
            read_reg2 = 3'd1;

            #5;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Write 0x1234 to Reg 2 and 0x5678 to Reg 5", test_num);


            @(negedge clk);
            write_reg = 3'd2;
            write_data = 16'h1234;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_reg = 3'd5;
            write_data = 16'h5678;
            write_enable = 1;
            @(posedge clk);

            #1;
            write_enable = 0;
            read_reg1 = 3'd2;
            read_reg2 = 3'd5;

            #5;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Attempt to write 0xDEAD with write_enable=0", test_num);


            @(negedge clk);
            write_reg = 3'd4;
            write_data = 16'hAAAA;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_reg = 3'd4;
            write_data = 16'hDEAD;
            write_enable = 0;
            @(posedge clk);

            #1;
            read_reg1 = 3'd4;
            read_reg2 = 3'd0;

            #5;
            #1;

            check_outputs(16'hAAAA, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Write to Reg 0 and Reg 7", test_num);


            @(negedge clk);
            write_reg = 3'd0;
            write_data = 16'hFFFF;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_reg = 3'd7;
            write_data = 16'h8888;
            write_enable = 1;
            @(posedge clk);

            #1;
            write_enable = 0;
            read_reg1 = 3'd0;
            read_reg2 = 3'd7;

            #5;
            #1;

            check_outputs(16'hFFFF, 16'h8888);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Overwrite Reg 3 and check updated value", test_num);


            @(negedge clk);
            write_reg = 3'd3;
            write_data = 16'h1111;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_reg = 3'd3;
            write_data = 16'h2222;
            write_enable = 1;
            @(posedge clk);

            #1;
            write_enable = 0;
            read_reg1 = 3'd3;
            read_reg2 = 3'd0;

            #5;
            #1;

            check_outputs(16'h2222, 16'h0000);
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
        input [15:0] expected_read_data1;
        input [15:0] expected_read_data2;
        begin
            if (expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1) &&
                expected_read_data2 === (expected_read_data2 ^ read_data2 ^ expected_read_data2)) begin
                $display("PASS");
                $display("  Outputs: read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data1=%h, read_data2=%h",
                         expected_read_data1, expected_read_data2);
                $display("  Got:      read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
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
        $dumpvars(0,clk, read_reg1, read_reg2, write_data, write_enable, write_reg, read_data1, read_data2);
    end

endmodule
