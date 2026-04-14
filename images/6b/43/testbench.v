`timescale 1ns/1ps

module ram_16x8_dp_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] raddr;
    reg [3:0] waddr;
    reg [7:0] wdata;
    reg we;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_16x8_dp dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
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
        raddr = 0;

        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %03d: Basic Write/Read at Address 5", test_num);


        we = 1;
        waddr = 4'h5;
        wdata = 8'hA5;
        @(posedge clk);
        #1;
        we = 0;


        raddr = 4'h5;
        #2;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %03d: Verify Write Enable (WE=0 prevents write)", test_num);


        we = 1; waddr = 4'hA; wdata = 8'h11;
        @(posedge clk);
        #1;


        we = 0; waddr = 4'hA; wdata = 8'hEE;
        @(posedge clk);
        #1;


        raddr = 4'hA;
        #2;

        #1;


        check_outputs(8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %03d: Write/Read at Highest Address (15)", test_num);

        we = 1;
        waddr = 4'hF;
        wdata = 8'hFF;
        @(posedge clk);
        #1;
        we = 0;

        raddr = 4'hF;
        #2;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %03d: Write/Read at Lowest Address (0)", test_num);

        we = 1;
        waddr = 4'h0;
        wdata = 8'h33;
        @(posedge clk);
        #1;
        we = 0;

        raddr = 4'h0;
        #2;

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %03d: Verify Asynchronous Read (No clock needed for read)", test_num);


        we = 1;
        waddr = 4'h1; wdata = 8'h11;
        @(posedge clk);
        #1;
        waddr = 4'h2; wdata = 8'h22;
        @(posedge clk);
        #1;
        we = 0;


        raddr = 4'h1;
        #2;
        if (rdata !== 8'h11) $display("Fail step 1: rdata=%h", rdata);

        raddr = 4'h2;
        #2;

        #1;


        check_outputs(8'h22);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase %03d: Simultaneous Write to Addr 8 and Read from Addr 4", test_num);


        we = 1; waddr = 4'h4; wdata = 8'h44;
        @(posedge clk);
        #1;


        we = 1; waddr = 4'h8; wdata = 8'h88;
        raddr = 4'h4;


        @(posedge clk);
        #1;


        raddr = 4'h8;
        #2;

        #1;


        check_outputs(8'h88);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Testcase %03d: Overwriting data at Address 7", test_num);

        we = 1; waddr = 4'h7; wdata = 8'hAA;
        @(posedge clk);
        #1;
        waddr = 4'h7; wdata = 8'h55;
        @(posedge clk);
        #1;
        we = 0;

        raddr = 4'h7;
        #2;

        #1;


        check_outputs(8'h55);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_16x8_dp Testbench");
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
        input [7:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,clk, raddr, waddr, wdata, we, rdata);
    end

endmodule
