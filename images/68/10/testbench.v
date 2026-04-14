`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr_r1;
    reg [1:0] addr_r2;
    reg [1:0] addr_w;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .addr_r1(addr_r1),
        .addr_r2(addr_r2),
        .addr_w(addr_w),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            we = 0;
            addr_w = 0;
            data_in = 0;
            addr_r1 = 0;
            addr_r2 = 0;

            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                we = 1;
                addr_w = i;
                data_in = 8'h00;
                @(negedge clk);
                we = 0;
            end
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write/Read Reg0", test_num);

            @(negedge clk);
            we = 1;
            addr_w = 2'b00;
            data_in = 8'hAA;

            @(negedge clk);
            we = 0;
            addr_r1 = 2'b00;
            addr_r2 = 2'b01;

            #1;
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write to Reg 1 and 2, read both", test_num);


            @(negedge clk);
            we = 1;
            addr_w = 2'b01;
            data_in = 8'h55;


            @(negedge clk);
            addr_w = 2'b10;
            data_in = 8'h33;

            @(negedge clk);
            we = 0;
            addr_r1 = 2'b01;
            addr_r2 = 2'b10;

            #1;
            #1;

            check_outputs(8'h55, 8'h33);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Verify Write Enable (we=0)", test_num);

            @(negedge clk);
            we = 0;
            addr_w = 2'b11;
            data_in = 8'hFF;

            @(negedge clk);
            addr_r1 = 2'b11;
            addr_r2 = 2'b00;

            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Read same register from both ports", test_num);

            @(negedge clk);
            we = 1;
            addr_w = 2'b11;
            data_in = 8'hBE;

            @(negedge clk);
            we = 0;
            addr_r1 = 2'b11;
            addr_r2 = 2'b11;

            #1;
            #1;

            check_outputs(8'hBE, 8'hBE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overwrite Reg 2", test_num);


            @(negedge clk);
            we = 1;
            addr_w = 2'b10;
            data_in = 8'h11;


            @(negedge clk);
            data_in = 8'h99;

            @(negedge clk);
            we = 0;
            addr_r1 = 2'b10;
            addr_r2 = 2'b00;

            #1;
            #1;

            check_outputs(8'h99, 8'h00);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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
        $dumpvars(0,addr_r1, addr_r2, addr_w, clk, data_in, we, data_out1, data_out2);
    end

endmodule
