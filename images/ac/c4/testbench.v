`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR_RD;
    reg [3:0] ADDR_WR;
    reg CLK;
    reg [7:0] DI;
    reg WE;
    wire [7:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .ADDR_RD(ADDR_RD),
        .ADDR_WR(ADDR_WR),
        .CLK(CLK),
        .DI(DI),
        .WE(WE),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            ADDR_WR = 0;
            ADDR_RD = 0;
            DI = 0;
            @(posedge CLK);
            #1;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            WE = 1;
            ADDR_WR = 4'h5;
            DI = 8'hAA;
            @(posedge CLK);
            #1;
            WE = 0;


            ADDR_RD = 4'h5;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify WE signal (Write inhibited when WE=0)", test_num);
            reset_dut();


            WE = 0;
            ADDR_WR = 4'hA;
            DI = 8'h55;
            @(posedge CLK);
            #1;


            ADDR_RD = 4'hA;
            @(posedge CLK);
            #1;



            if (DO !== 8'h55) begin
                $display("PASS: Data was not written when WE=0");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Data was written despite WE=0");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Read and Write (Different Addresses)", test_num);
            reset_dut();


            WE = 1;
            ADDR_WR = 4'h2;
            DI = 8'h11;
            @(posedge CLK);
            #1;


            WE = 1;
            ADDR_WR = 4'h3;
            DI = 8'h22;
            ADDR_RD = 4'h2;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwriting memory location", test_num);
            reset_dut();


            WE = 1;
            ADDR_WR = 4'hF;
            DI = 8'hCC;
            @(posedge CLK);
            #1;


            WE = 1;
            ADDR_WR = 4'hF;
            DI = 8'hDD;
            @(posedge CLK);
            #1;
            WE = 0;


            ADDR_RD = 4'hF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Full Memory Sweep", test_num);
            reset_dut();


            WE = 1;
            for (i = 0; i < 16; i = i + 1) begin
                ADDR_WR = i;
                DI = i + 8'h10;
                @(posedge CLK);
                #1;
            end
            WE = 0;


            ADDR_RD = 4'hF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hF + 8'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram Testbench");
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
        input [7:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,ADDR_RD, ADDR_WR, CLK, DI, WE, DO);
    end

endmodule
