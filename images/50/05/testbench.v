`timescale 1ns/1ps

module reg_file_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] r_addr_a;
    reg [2:0] r_addr_b;
    reg rst_n;
    reg [2:0] w_addr;
    reg [31:0] w_data;
    reg we;
    wire [31:0] r_data_a;
    wire [31:0] r_data_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_32bit dut (
        .clk(clk),
        .r_addr_a(r_addr_a),
        .r_addr_b(r_addr_b),
        .rst_n(rst_n),
        .w_addr(w_addr),
        .w_data(w_data),
        .we(we),
        .r_data_a(r_data_a),
        .r_data_b(r_data_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            we = 0;
            w_addr = 0;
            w_data = 0;
            r_addr_a = 0;
            r_addr_b = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verification of Reset State", test_num);
            reset_dut();


            r_addr_a = 3'd3;
            r_addr_b = 3'd7;

            #2;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write and Dual Port Read", test_num);
            reset_dut();

            @(posedge clk);
            we = 1;
            w_addr = 3'd2;
            w_data = 32'hDEADBEEF;

            @(posedge clk);
            we = 0;
            r_addr_a = 3'd2;
            r_addr_b = 3'd2;

            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write Enable (WE) Logic Check", test_num);
            reset_dut();

            @(posedge clk);
            we = 0;
            w_addr = 3'd5;
            w_data = 32'hCAFEBABE;

            @(posedge clk);
            r_addr_a = 3'd5;
            r_addr_b = 3'd0;

            #2;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple Register Independence", test_num);
            reset_dut();


            @(posedge clk);
            we = 1; w_addr = 3'd1; w_data = 32'h1111_1111;


            @(posedge clk);
            we = 1; w_addr = 3'd4; w_data = 32'h4444_4444;

            @(posedge clk);
            we = 0;
            r_addr_a = 3'd1;
            r_addr_b = 3'd4;

            #2;
            #1;

            check_outputs(32'h1111_1111, 32'h4444_4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite Operation", test_num);
            reset_dut();


            @(posedge clk);
            we = 1; w_addr = 3'd6; w_data = 32'hAAAA_AAAA;


            @(posedge clk);
            we = 1; w_addr = 3'd6; w_data = 32'h5555_5555;

            @(posedge clk);
            we = 0;
            r_addr_a = 3'd6;
            r_addr_b = 3'd0;

            #2;
            #1;

            check_outputs(32'h5555_5555, 32'h00000000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: All Registers Stress Test", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                we = 1;
                w_addr = i;
                w_data = (i << 24) | (i << 16) | (i << 8) | i;
            end

            @(posedge clk);
            we = 0;
            r_addr_a = 3'd0;
            r_addr_b = 3'd7;

            #2;
            #1;

            check_outputs(32'h00000000, 32'h07070707);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_32bit Testbench");
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
        input [31:0] expected_r_data_a;
        input [31:0] expected_r_data_b;
        begin
            if (expected_r_data_a === (expected_r_data_a ^ r_data_a ^ expected_r_data_a) &&
                expected_r_data_b === (expected_r_data_b ^ r_data_b ^ expected_r_data_b)) begin
                $display("PASS");
                $display("  Outputs: r_data_a=%h, r_data_b=%h",
                         r_data_a, r_data_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data_a=%h, r_data_b=%h",
                         expected_r_data_a, expected_r_data_b);
                $display("  Got:      r_data_a=%h, r_data_b=%h",
                         r_data_a, r_data_b);
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
        $dumpvars(0,clk, r_addr_a, r_addr_b, rst_n, w_addr, w_data, we, r_data_a, r_data_b);
    end

endmodule
