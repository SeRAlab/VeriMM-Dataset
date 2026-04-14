`timescale 1ns/1ps

module ram_64x32_dp_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] raddr;
    reg [5:0] waddr;
    reg [31:0] wdata;
    reg we;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_64x32_dp dut (
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


            we = 1;
            waddr = 6'd0;
            wdata = 32'hDEADBEEF;
            @(posedge clk);


            we = 0;
            raddr = 6'd0;
            @(posedge clk);


            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            we = 1;
            waddr = 6'd63;
            wdata = 32'hCAFEBABE;
            @(posedge clk);


            we = 0;
            raddr = 6'd63;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            we = 1;
            waddr = 6'd10;
            wdata = 32'h11111111;
            @(posedge clk);


            we = 0;
            waddr = 6'd10;
            wdata = 32'hEEEEEEEE;
            @(posedge clk);


            raddr = 6'd10;
            @(posedge clk);

            #1;

            #1;


            check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            we = 1;
            waddr = 6'd1; wdata = 32'h00000001; @(posedge clk);
            waddr = 6'd2; wdata = 32'h00000002; @(posedge clk);
            waddr = 6'd3; wdata = 32'h00000003; @(posedge clk);


            we = 0;
            raddr = 6'd3;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            we = 1;
            waddr = 6'd5;
            wdata = 32'hAAAA5555;
            @(posedge clk);


            we = 1;
            waddr = 6'd6;
            wdata = 32'hBBBB6666;
            raddr = 6'd5;
            @(posedge clk);

            #1;

            #1;


            check_outputs(32'hAAAA5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_64x32_dp Testbench");
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
        input [31:0] expected_rdata;
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
