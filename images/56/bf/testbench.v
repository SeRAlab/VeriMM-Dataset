`timescale 1ns/1ps

module reg_file_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] raddr1;
    reg [3:0] raddr2;
    reg [3:0] waddr;
    reg [7:0] wdata;
    reg we;
    wire [7:0] rdata1;
    wire [7:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_8bit dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            waddr = 0;
            wdata = 0;
            raddr1 = 0;
            raddr2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Dual Port Read", test_num);


            we = 1;
            waddr = 4'd5;
            wdata = 8'hAA;
            @(posedge clk);
            #1;
            we = 0;


            raddr1 = 4'd5;
            raddr2 = 4'd5;
            #1;

            #1;


            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Register Write and Independent Read", test_num);


            we = 1;
            waddr = 4'd2;
            wdata = 8'h55;
            @(posedge clk);
            #1;


            waddr = 4'd12;
            wdata = 8'h33;
            @(posedge clk);
            #1;
            we = 0;


            raddr1 = 4'd2;
            raddr2 = 4'd12;
            #1;

            #1;


            check_outputs(8'h55, 8'h33);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);


            we = 0;
            waddr = 4'd7;
            wdata = 8'hFF;
            @(posedge clk);
            #1;


            raddr1 = 4'd7;
            raddr2 = 4'd0;
            #1;






            we = 1; waddr = 4'd7; wdata = 8'hBE;
            @(posedge clk); #1;


            we = 0; waddr = 4'd7; wdata = 8'hEF;
            @(posedge clk); #1;

            raddr1 = 4'd7;
            #1;
            #1;

            check_outputs(8'hBE, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Read Timing", test_num);


            we = 1; waddr = 4'd1; wdata = 8'h11;
            @(posedge clk); #1;
            waddr = 4'd2; wdata = 8'h22;
            @(posedge clk); #1;
            we = 0;


            raddr1 = 4'd1;
            #2;


            raddr1 = 4'd2;
            #1;

            #1;


            check_outputs(8'h22, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Register Overwrite", test_num);

            we = 1;
            waddr = 4'd10;
            wdata = 8'hA1;
            @(posedge clk);
            #1;
            wdata = 8'hB2;
            @(posedge clk);
            #1;
            we = 0;

            raddr1 = 4'd10;
            raddr2 = 4'd10;
            #1;

            #1;


            check_outputs(8'hB2, 8'hB2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_8bit Testbench");
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
        input [7:0] expected_rdata1;
        input [7:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,clk, raddr1, raddr2, waddr, wdata, we, rdata1, rdata2);
    end

endmodule
