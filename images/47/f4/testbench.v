`timescale 1ns/1ps

module ram_512x32_sp_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] addr;
    reg clk;
    reg [31:0] wdata;
    reg we;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_512x32_sp dut (
        .addr(addr),
        .clk(clk),
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
            addr = 0;
            wdata = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);


            @(negedge clk);
            addr = 9'h000;
            wdata = 32'hA5A5_5A5A;
            we = 1;
            @(negedge clk);
            we = 0;




            addr = 9'h000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (Address 511)", test_num);


            @(negedge clk);
            addr = 9'd511;
            wdata = 32'hFFFF_FFFF;
            we = 1;
            @(negedge clk);
            we = 0;


            addr = 9'd511;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification (WE=0)", test_num);


            @(negedge clk);
            addr = 9'd10;
            wdata = 32'h1234_5678;
            we = 1;
            @(negedge clk);


            wdata = 32'hDEAD_BEEF;
            we = 0;
            @(negedge clk);


            addr = 9'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting existing data", test_num);


            @(negedge clk);
            addr = 9'd256;
            wdata = 32'h0000_1111;
            we = 1;
            @(negedge clk);


            wdata = 32'hEEEE_FFFF;
            we = 1;
            @(negedge clk);
            we = 0;


            addr = 9'd256;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hEEEE_FFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Reads", test_num);


            @(negedge clk);
            addr = 9'd1; wdata = 32'hC0DE_0001; we = 1;
            @(negedge clk);

            addr = 9'd2; wdata = 32'hC0DE_0002; we = 1;
            @(negedge clk);
            we = 0;


            addr = 9'd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hC0DE_0002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_512x32_sp Testbench");
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
        $dumpvars(0,addr, clk, wdata, we, rdata);
    end

endmodule
