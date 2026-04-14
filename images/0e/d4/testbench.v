`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg ACK;
    reg READ_REQ;
    reg WRITE_REQ;
    reg clk;
    reg rst_n;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .ACK(ACK),
        .READ_REQ(READ_REQ),
        .WRITE_REQ(WRITE_REQ),
        .clk(clk),
        .rst_n(rst_n),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ACK = 0;
            READ_REQ = 0;
            WRITE_REQ = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE -> READ_WAIT transition", test_num);
            reset_dut();
            @(posedge clk);
            READ_REQ = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: READ_WAIT -> IDLE transition via ACK", test_num);
            reset_dut();
            @(posedge clk);
            READ_REQ = 1;
            @(posedge clk);
            READ_REQ = 0;
            ACK = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: IDLE -> WRITE_WAIT transition", test_num);
            reset_dut();
            @(posedge clk);
            WRITE_REQ = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: WRITE_WAIT -> IDLE transition via ACK", test_num);
            reset_dut();
            @(posedge clk);
            WRITE_REQ = 1;
            @(posedge clk);
            WRITE_REQ = 0;
            ACK = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Persistence in READ_WAIT without ACK", test_num);
            reset_dut();
            @(posedge clk);
            READ_REQ = 1;
            @(posedge clk);
            READ_REQ = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous READ/WRITE REQ in IDLE", test_num);
            reset_dut();
            @(posedge clk);
            READ_REQ = 1;
            WRITE_REQ = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Ignore READ_REQ while in WRITE_WAIT", test_num);
            reset_dut();
            @(posedge clk);
            WRITE_REQ = 1;
            @(posedge clk);
            WRITE_REQ = 0;
            READ_REQ = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,ACK, READ_REQ, WRITE_REQ, clk, rst_n, state);
    end

endmodule
