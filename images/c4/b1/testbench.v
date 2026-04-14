`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] raddr1;
    reg [5:0] raddr2;
    reg [5:0] waddr;
    reg [31:0] wdata;
    reg wen;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
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
            wen = 0;
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
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            waddr = 6'd1;
            wdata = 32'hDEADBEEF;


            @(negedge clk);
            wen = 1;
            waddr = 6'd2;
            wdata = 32'hCAFEBABE;


            @(negedge clk);
            wen = 0;
            raddr1 = 6'd1;
            raddr2 = 6'd2;

            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Boundary Registers (0 and 31)", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            waddr = 6'd0;
            wdata = 32'h11112222;


            @(negedge clk);
            wen = 1;
            waddr = 6'd31;
            wdata = 32'h33334444;

            @(negedge clk);
            wen = 0;
            raddr1 = 6'd0;
            raddr2 = 6'd31;

            #2;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write Enable functionality", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            waddr = 6'd5;
            wdata = 32'hAAAAAAAA;


            @(negedge clk);
            wen = 0;
            waddr = 6'd5;
            wdata = 32'hBBBBBBBB;


            @(negedge clk);
            raddr1 = 6'd5;
            raddr2 = 6'd5;

            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dual Port Read from same register", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            waddr = 6'd10;
            wdata = 32'h5555AAAA;


            @(negedge clk);
            wen = 0;
            raddr1 = 6'd10;
            raddr2 = 6'd10;

            #2;
            #1;

            check_outputs(32'h5555AAAA, 32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwriting a register", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            waddr = 6'd15;
            wdata = 32'h00001111;


            @(negedge clk);
            wen = 1;
            waddr = 6'd15;
            wdata = 32'hFFFFEEEE;

            @(negedge clk);
            wen = 0;
            raddr1 = 6'd15;
            raddr2 = 6'd0;

            #2;
            #1;

            check_outputs(32'hFFFFEEEE, rdata2);
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
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
        $dumpvars(0,clk, raddr1, raddr2, waddr, wdata, wen, rdata1, rdata2);
    end

endmodule
